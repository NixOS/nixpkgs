{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uriparser";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "uriparser";
    repo = "uriparser";
    tag = "uriparser-${finalAttrs.version}";
    hash = "sha256-fICEX/Hf6Shzwt1mY0SOwaYceXWf203yjUWXq874p7E=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "URIPARSER_BUILD_DOCS" false)
    (lib.cmakeBool "URIPARSER_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  nativeCheckInputs = [ gtest ];

  meta = {
    changelog = "https://github.com/uriparser/uriparser/blob/uriparser-${finalAttrs.version}/ChangeLog";
    description = "Strictly RFC 3986 compliant URI parsing library";
    longDescription = ''
      uriparser is a strictly RFC 3986 compliant URI parsing and handling library written in C.
      API documentation is available on uriparser website.
    '';
    homepage = "https://uriparser.github.io/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bosu ];
    mainProgram = "uriparse";
    platforms = lib.platforms.unix;
  };
})
