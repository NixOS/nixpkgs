{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tagref";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = "tagref";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-tsiotSQsf3wlp5wlzV0MHavCieW9LMb3Ei+eKve0O/4=";
  };

  cargoHash = "sha256-3nGdM3Qv3y5byQI1Txv0VNi2cQZ7RP5tEXFWuom2SOY=";

  meta = {
    description = "Manage cross-references in your code";
    homepage = "https://github.com/stepchowfun/tagref";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.yusdacra ];
    platforms = lib.platforms.unix;
    mainProgram = "tagref";
  };
})
