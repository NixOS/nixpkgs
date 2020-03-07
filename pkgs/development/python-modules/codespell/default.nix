{ lib, buildPythonApplication, fetchPypi, pytest, chardet }:
buildPythonApplication rec {
  pname = "codespell";
  version = "1.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1s9dl07ib77gq0iq26mrdpl1c46nkfm7nlhqwxpx5vvs6a1pqfxz";
  };

  checkInputs = [ pytest chardet ];
  checkPhase = ''
    # We don't want to be affected by the presence of these
    rm -r codespell_lib setup.cfg
    # test_command assumes too much about the execution environment
    pytest --pyargs codespell_lib.tests -k "not test_command"
  '';

  meta = {
    description = "Fix common misspellings in source code";
    homepage = "https://github.com/codespell-project/codespell";
    license = with lib.licenses; [ gpl2 cc-by-sa-30 ];
    maintainers = with lib.maintainers; [ johnazoidberg ];
    platforms = lib.platforms.all;
  };
}
