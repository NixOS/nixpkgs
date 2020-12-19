{ stdenv, fetchurl, getopt, util-linux, gperf }:

stdenv.mkDerivation rec {
  pname = "libseccomp";
  version = "2.5.1";

  src = fetchurl {
    url = "https://github.com/seccomp/libseccomp/releases/download/v${version}/libseccomp-${version}.tar.gz";
    sha256 = "0m8dlg1v7kflcxvajs4p76p275qwsm2abbf5mfapkakp7hw7wc7f";
  };

  outputs = [ "out" "lib" "dev" "man" "pythonsrc" ];

  nativeBuildInputs = [ gperf ];
  buildInputs = [ getopt ];

  patchPhase = ''
    patchShebangs .
  '';

  checkInputs = [ util-linux ];
  doCheck = false; # dependency cycle

  # Hack to ensure that patchelf --shrink-rpath get rids of a $TMPDIR reference.
  preFixup = "rm -rfv src";

  # Copy the python module code into a tarball that we can export and use as the
  # src input for buildPythonPackage calls
  postInstall = ''
    cp -R ./src/python/ tmp-pythonsrc/
    tar -zcf $pythonsrc --mtime="@$SOURCE_DATE_EPOCH" --sort=name --transform s/tmp-pythonsrc/python-foundationdb/ ./tmp-pythonsrc/
  '';

  meta = with stdenv.lib; {
    description = "High level library for the Linux Kernel seccomp filter";
    homepage = "https://github.com/seccomp/libseccomp";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    badPlatforms = [
      "alpha-linux"
      "riscv32-linux"
      "sparc-linux"
      "sparc64-linux"
    ];
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
