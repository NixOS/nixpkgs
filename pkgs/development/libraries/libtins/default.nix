{ boost, cmake, fetchFromGitHub, gtest, libpcap, openssl, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "libtins";
  version = "4.4";

  src = fetchFromGitHub {
    owner = "mfontanini";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mXbinXh/CO0SZZ71+K+FozbHCCoi12+AIa2o+P0QmUw=";
  };

  postPatch = ''
    rm -rf googletest
    cp -r ${gtest.src} googletest
    chmod -R a+w googletest
  '';

  nativeBuildInputs = [ cmake gtest ];
  buildInputs = [
    openssl
    libpcap
    boost
  ];

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
    "--with-boost=${boost.dev}"
  ];

  doCheck = true;
  checkTarget = "tests test";

  meta = with lib; {
    description = "High-level, multiplatform C++ network packet sniffing and crafting library";
    homepage = "https://libtins.github.io/";
    changelog = "https://raw.githubusercontent.com/mfontanini/${pname}/v${version}/CHANGES.md";
    license = lib.licenses.bsd2;
    maintainers = with maintainers; [ fdns ];
    platforms = lib.platforms.unix;
  };
}
