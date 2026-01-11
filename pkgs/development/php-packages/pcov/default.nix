{
  buildPecl,
  lib,
  pcre2,
  fetchFromGitHub,
  fetchpatch,
}:

let
  version = "1.0.12";
in
buildPecl {
  inherit version;
  pname = "pcov";

  src = fetchFromGitHub {
    owner = "krakjoe";
    repo = "pcov";
    tag = "v${version}";
    hash = "sha256-lyY17Y9chpTO8oeWmDGSh0YSnipYqCuy1qmn9su5Eu8=";
  };

  buildInputs = [ pcre2 ];

  patches = [
    # Allow building for PHP 8.4
    (fetchpatch {
      url = "https://github.com/krakjoe/pcov/commit/7d764c7c2555e8287351961d72be3ebec4d8743f.patch";
      hash = "sha256-5wIHrrCwUXQpPdUg+3Kwyop5yvOzQQ3qc4pQXU8q2OM=";
    })
  ];

  meta = {
    changelog = "https://github.com/krakjoe/pcov/releases/tag/v${version}";
    description = "Self contained php-code-coverage compatible driver for PHP";
    license = lib.licenses.php301;
    homepage = "https://github.com/krakjoe/pcov";
    teams = [ lib.teams.php ];
  };
}
