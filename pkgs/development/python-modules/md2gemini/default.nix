{ lib, buildPythonPackage, fetchPypi, mistune_2_0, cjkwrap, wcwidth
, pytestCheckHook }:

buildPythonPackage rec {
  pname = "md2gemini";
  version = "1.9.0";

  propagatedBuildInputs = [ mistune_2_0 cjkwrap wcwidth ];
  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "md2gemini" ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "775cee2be36aa0f4b7ea2861f2ac7d80e113f78b40a58f92192b6c73f6c84e75";
  };

  meta = with lib; {
    description = "Markdown to Gemini text format conversion library";
    homepage = "https://github.com/makeworld-the-better-one/md2gemini";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.kaction ];
  };
}
