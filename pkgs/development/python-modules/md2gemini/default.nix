{ lib, buildPythonPackage, fetchPypi, mistune_2_0, cjkwrap, wcwidth
, pytestCheckHook }:

buildPythonPackage rec {
  pname = "md2gemini";
  version = "1.8.1";

  propagatedBuildInputs = [ mistune_2_0 cjkwrap wcwidth ];
  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "md2gemini" ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mfa0f0m762168fbsxjr1cx9yhj82dr8z1d28jl6hj9bkqnvvwiy";
  };

  meta = with lib; {
    description = "Markdown to Gemini text format conversion library";
    homepage = "https://github.com/makeworld-the-better-one/md2gemini";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.kaction ];
  };
}
