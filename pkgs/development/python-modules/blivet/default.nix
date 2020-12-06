{ stdenv, fetchFromGitHub, buildPythonPackage, pykickstart, pyparted, pyblock
, pyudev, six, libselinux, multipath-tools, lsof, util-linux
}:

buildPythonPackage rec {
  pname = "blivet";
  version = "0.67";

  src = fetchFromGitHub {
    owner = "dwlehman";
    repo = "blivet";
    rev = "${pname}-${version}";
    sha256 = "1gk94ghjrxfqnx53hph1j2s7qcv86fjz48is7l099q9c24rjv8ky";
  };

  postPatch = ''
    sed -i \
      -e 's|"multipath"|"${multipath-tools}/sbin/multipath"|' \
      -e '/^def set_friendly_names/a \    return False' \
      blivet/devicelibs/mpath.py
    sed -i -e '/"wipefs"/ {
      s|wipefs|${util-linux}/sbin/wipefs|
      s/-f/--force/
    }' blivet/formats/__init__.py
    sed -i -e 's|"lsof"|"${lsof}/bin/lsof"|' blivet/formats/fs.py
    sed -i -r -e 's|"(u?mount)"|"${util-linux}/bin/\1"|' blivet/util.py
  '';

  propagatedBuildInputs = [
    pykickstart pyparted pyblock pyudev libselinux
    six
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://fedoraproject.org/wiki/Blivet";
    description = "Module for management of a system's storage configuration";
    license = with licenses; [ gpl2Plus lgpl21Plus ];
    platforms = platforms.linux;
  };
}
