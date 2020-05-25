{ stdenv, fetchFromGitHub, darwin }:

stdenv.mkDerivation rec {
  pname = "cctz";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cctz";
    rev = "v${version}";
    sha256 = "0254xfwscfkjc3fbvx6qgifr3pwkc2rb03z8pbvvqy098di9alhr";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Foundation;

  installTargets = [ "install_hdrs" "install_shared_lib" ];

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -id $out/lib/libcctz.so $out/lib/libcctz.so
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/google/cctz";
    description = "C++ library for translating between absolute and civil times";
    license = licenses.asl20;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.all;
  };
}
