{
  lib,
<<<<<<< HEAD
  stdenv,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  babel,
  buildPythonPackage,
  cssselect,
  fetchFromGitHub,
  glibcLocales,
  isodate,
  leather,
  lxml,
  parsedatetime,
  pyicu,
  pytestCheckHook,
  python-slugify,
  pythonOlder,
  pytimeparse,
  setuptools,
}:

buildPythonPackage rec {
  pname = "agate";
<<<<<<< HEAD
  version = "1.14.0";
  pyproject = true;

=======
  version = "1.13.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "wireservice";
    repo = "agate";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-Pp5pUOycDGzymIvwWoDAaOomTsxAfDNdSGwOG5a25Hc=";
=======
    hash = "sha256-jDeme5eOuX9aQ+4A/pLnH/SuCOztyZzKdSBYKVC63Bk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    babel
    isodate
    leather
    parsedatetime
    python-slugify
    pytimeparse
  ];

  nativeCheckInputs = [
    cssselect
    glibcLocales
    lxml
    pyicu
    pytestCheckHook
  ];

<<<<<<< HEAD
  disabledTests = lib.optionals stdenv.isDarwin [
    # Output is slightly different on macOS
    "test_cast_format_locale"
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pythonImportsCheck = [ "agate" ];

  meta = {
    description = "Python data analysis library that is optimized for humans instead of machines";
    homepage = "https://github.com/wireservice/agate";
    changelog = "https://github.com/wireservice/agate/blob/${version}/CHANGELOG.rst";
    license = with lib.licenses; [ mit ];
    maintainers = [ ];
  };
}
