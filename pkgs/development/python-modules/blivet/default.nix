{ stdenv, fetchurl, buildPythonPackage, pykickstart, pyparted, pyblock
, libselinux, cryptsetup, multipath_tools, lsof, utillinux
, useNixUdev ? true, udev ? null
# This is only used when useNixUdev is false
, udevSoMajor ? 1
}:

assert useNixUdev -> udev != null;

let
  pyenable = { enablePython = true; };
  selinuxWithPython = libselinux.override pyenable;
  cryptsetupWithPython = cryptsetup.override pyenable;
in buildPythonPackage rec {
  name = "blivet-${version}";
  version = "0.17-1";

  src = fetchurl {
    url = "https://git.fedorahosted.org/cgit/blivet.git/snapshot/"
        + "${name}.tar.bz2";
    sha256 = "1k3mws2q0ryb7422mml6idmaasz2i2v6ngyvg6d976dx090qnmci";
  };

  postPatch = ''
    sed -i -e 's|"multipath"|"${multipath_tools}/sbin/multipath"|' \
      blivet/devicelibs/mpath.py blivet/devices.py
    sed -i -e '/"wipefs"/ {
      s|wipefs|${utillinux}/sbin/wipefs|
      s/-f/--force/
    }' blivet/formats/__init__.py
    sed -i -e 's|"lsof"|"${lsof}/bin/lsof"|' blivet/formats/fs.py
    sed -i -r -e 's|"(u?mount)"|"${utillinux}/bin/\1"|' blivet/util.py
    sed -i '/pvscan/s/, *"--cache"//' blivet/devicelibs/lvm.py
  '' + (if useNixUdev then ''
    sed -i -e '/find_library/,/find_library/ {
      c libudev = "${udev}/lib/libudev.so.1"
    }' blivet/pyudev.py
  '' else ''
    sed -i \
      -e '/^somajor *=/s/=.*/= ${toString udevSoMajor}/p' \
      -e 's|common =.*|& + ["/lib/x86_64-linux-gnu", "/lib/i686-linux-gnu"]|' \
      blivet/pyudev.py
  '');

  propagatedBuildInputs = [
    pykickstart pyparted pyblock selinuxWithPython cryptsetupWithPython
  ] ++ stdenv.lib.optional useNixUdev udev;

  # tests are currently _heavily_ broken upstream
  doCheck = false;

  meta = {
    homepage = "https://fedoraproject.org/wiki/Blivet";
    description = "Module for management of a system's storage configuration";
    license = [ "GPLv2+" "LGPLv2.1+" ];
    platforms = stdenv.lib.platforms.linux;
  };
}
