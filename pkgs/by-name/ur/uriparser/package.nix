{
  lib,
  stdenv,
  fetchurl,
  cmake,
  gtest,
}:

stdenv.mkDerivation rec {
  pname = "uriparser";
  version = "0.9.8";

  # Release tarball differs from source tarball
  src = fetchurl {
    url = "https://github.com/uriparser/uriparser/releases/download/${pname}-${version}/${pname}-${version}.tar.bz2";
    hash = "sha256-ctG1Wb46GAb3iKPZvjShsGPUKqI4spuk7mM9bv/NM70=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DURIPARSER_BUILD_DOCS=OFF"
  ] ++ lib.optional (!doCheck) "-DURIPARSER_BUILD_TESTS=OFF";

  nativeCheckInputs = [ gtest ];
  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  meta = with lib; {
    changelog = "https://github.com/uriparser/uriparser/blob/uriparser-${version}/ChangeLog";
    description = "Strictly RFC 3986 compliant URI parsing library";
    longDescription = ''
      uriparser is a strictly RFC 3986 compliant URI parsing and handling library written in C.
      API documentation is available on uriparser website.
    '';
    homepage = "https://uriparser.github.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bosu ];
    mainProgram = "uriparse";
    platforms = platforms.unix;
  };
}
