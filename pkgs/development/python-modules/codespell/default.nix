{ lib
, aspell-python
, aspellDicts
, buildPythonApplication
, chardet
, fetchFromGitHub
, pytestCheckHook
, pytest-dependency
, setuptools-scm
}:

buildPythonApplication rec {
  pname = "codespell";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "codespell-project";
    repo = "codespell";
    rev = "v${version}";
    sha256 = "sha256-zXHqaZzGIS7BOFc/kPzA4sgpoEmXuaKHdOcKpMWWeOI=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=codespell_lib" "" \
      --replace "--cov-report=" ""
  '';

  nativeBuildInputs = [ setuptools-scm ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  checkInputs = [
    aspell-python
    chardet
    pytestCheckHook
    pytest-dependency
  ];

  preCheck = ''
    export ASPELL_CONF="dict-dir ${aspellDicts.en}/lib/aspell"
  '';

  disabledTests = [
    # tries to run not fully installed script
    "test_command"
    # error 'dateset' should not be in aspell dictionaries (en, en_GB, en_US, en_CA, en_AU) for dictionary /build/source/codespell_lib/tests/../data/dictionary.txt
    "test_dictionary_formatting"
  ];

  pythonImportsCheck = [ "codespell_lib" ];

  meta = with lib; {
    description = "Fix common misspellings in source code";
    homepage = "https://github.com/codespell-project/codespell";
    license = with licenses; [ gpl2Only cc-by-sa-30 ];
    maintainers = with maintainers; [ johnazoidberg SuperSandro2000 ];
  };
}
