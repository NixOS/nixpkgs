{ lib, stdenv, fetchFromGitHub, jdk, jre, ant, libffi, texinfo, pkg-config }:

stdenv.mkDerivation rec {
  pname = "jffi";
  version = "1.3.10";

  src = fetchFromGitHub {
    owner = "jnr";
    repo = "jffi";
    rev = "jffi-${version}";
    sha256 = "sha256-2Y0l1bDr/f3vxwRjDX62xeC5pUmIbk4XH5prh8c91As=";
  };

  nativeBuildInputs = [ jdk ant texinfo pkg-config ];
  buildInputs = [ libffi ] ;

  buildPhase = ''
    # The pkg-config script in the build.xml doesn't work propery
    # set the lib path manually to work around this.
    export LIBFFI_LIBS="${libffi}/lib/libffi.so"

    ant -Duse.system.libffi=1 jar
    ant -Duse.system.libffi=1 archive-platform-jar
  '';

  installPhase = ''
    mkdir -p $out/share/java
    cp -r dist/* $out/share/java
  '';

  doCheck = true;
  checkPhase = ''
    # The pkg-config script in the build.xml doesn't work propery
    # set the lib path manually to work around this.
    export LIBFFI_LIBS="${libffi}/lib/libffi.so"

    ant -Duse.system.libffi=1 test
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Java Foreign Function Interface ";
    homepage = "https://github.com/jnr/jffi";
    platforms = platforms.unix;
    license = licenses.asl20;
    maintainers = with maintainers; [ bachp ];
  };
}
