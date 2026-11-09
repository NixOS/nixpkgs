{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  pcre2,
}:

buildDunePackage (finalAttrs: {
  pname = "inifiles";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "ahrefs";
    repo = "inifiles";
    tag = finalAttrs.version;
    hash = "sha256-BZ9rOKnUqSQCyPd/EPmyHRY9kHlE4JVqjxH6UF641Kg=";
  };

  propagatedBuildInputs = [
    pcre2
  ];

  meta = {
    description = "Small OCaml library to read and write .ini files";
    homepage = "https://github.com/ahrefs/inifiles";
    license = lib.licenses.lgpl21Plus;
  };
})
