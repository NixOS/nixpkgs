{ lib, stdenv, fetchurl, getopt, util-linuxMinimal, which, gperf, nix-update-script }:

stdenv.mkDerivation rec {
  pname = "libseccomp";
  version = "2.5.4";

  src = fetchurl {
    url = "https://github.com/seccomp/libseccomp/releases/download/v${version}/libseccomp-${version}.tar.gz";
    sha256 = "sha256-2CkCQAQFzwBoV07z3B/l9ZJiB1Q7oa5vjnoVdjUdy9s=";
  };

  outputs = [ "out" "lib" "dev" "man" "pythonsrc" ];

  nativeBuildInputs = [ gperf ];
  buildInputs = [ getopt ];

  patchPhase = ''
    patchShebangs .
  '';

  checkInputs = [ util-linuxMinimal which ];
  doCheck = true;

  # Hack to ensure that patchelf --shrink-rpath get rids of a $TMPDIR reference.
  preFixup = "rm -rfv src";

  # Copy the python module code into a tarball that we can export and use as the
  # src input for buildPythonPackage calls
  postInstall = ''
    cp -R ./src/python/ tmp-pythonsrc/
    tar -zcf $pythonsrc --mtime="@$SOURCE_DATE_EPOCH" --sort=name --transform s/tmp-pythonsrc/python-foundationdb/ ./tmp-pythonsrc/
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "High level library for the Linux Kernel seccomp filter";
    homepage = "https://github.com/seccomp/libseccomp";
    license = licenses.lgpl21Only;
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
