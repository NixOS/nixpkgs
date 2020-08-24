{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, pkgconfig, which
, gettext, libffi, libiconv, libtasn1
}:

stdenv.mkDerivation rec {
  pname = "p11-kit";
  version = "0.23.21";

  src = fetchFromGitHub {
    owner = "p11-glue";
    repo = pname;
    rev = version;
    sha256 = "1w24brn8j3vwfp07p2hldw2ci06pk1cx1dvjk8jjxkccp20fk958";
  };

  outputs = [ "out" "dev"];
  outputBin = "dev";

  nativeBuildInputs = [ autoreconfHook pkgconfig which ];
  buildInputs = [ gettext libffi libiconv libtasn1 ];

  autoreconfPhase = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-trust-paths=/etc/ssl/certs/ca-certificates.crt"
  ];

  enableParallelBuilding = true;

  doCheck = !stdenv.isDarwin;

  installFlags = [
    "exampledir=${placeholder "out"}/etc/pkcs11"
  ];

  meta = with stdenv.lib; {
    description = "Library for loading and sharing PKCS#11 modules";
    longDescription = ''
      Provides a way to load and enumerate PKCS#11 modules.
      Provides a standard configuration setup for installing
      PKCS#11 modules in such a way that they're discoverable.
    '';
    homepage = "https://p11-glue.github.io/p11-glue/p11-kit.html";
    platforms = platforms.all;
    license = licenses.bsd3;
  };
}
