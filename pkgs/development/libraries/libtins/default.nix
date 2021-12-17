{ boost, cmake, fetchFromGitHub, gtest, libpcap, openssl, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "libtins";
  version = "4.3";

  src = fetchFromGitHub {
    owner = "mfontanini";
    repo = pname;
    rev = "v${version}";
    sha256 = "09ah1a7ska7xiki7625mn1d8i96il3hxbkc39ba8fn1a5383kmqa";
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
  preCheck = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}$PWD${placeholder "out"}/lib
    export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH''${DYLD_LIBRARY_PATH:+:}$PWD${placeholder "out"}/lib
  '';
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
