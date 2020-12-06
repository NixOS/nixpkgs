{ lib, buildPythonApplication, fetchPypi, pytest, chardet }:

buildPythonApplication rec {
  pname = "codespell";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dd9983e096b9f7ba89dd2d2466d1fc37231d060f19066331b9571341363c77b8";
  };

  # no tests in pypi tarball
  doCheck = false;
  checkInputs = [ pytest chardet ];
  checkPhase = ''
    # We don't want to be affected by the presence of these
    rm -r codespell_lib setup.cfg
    # test_command assumes too much about the execution environment
    pytest --pyargs codespell_lib.tests -k "not test_command"
  '';

  pythonImportsCheck = [ "codespell_lib" ];

  meta = {
    description = "Fix common misspellings in source code";
    homepage = "https://github.com/codespell-project/codespell";
    license = with lib.licenses; [ gpl2 cc-by-sa-30 ];
    maintainers = with lib.maintainers; [ johnazoidberg ];
    platforms = lib.platforms.all;
  };
}
