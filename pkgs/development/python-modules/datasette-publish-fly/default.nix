{ buildPythonPackage
, fetchFromGitHub
, lib
, datasette
, pytestCheckHook
, pytest-asyncio
, sqlite-utils
}:

buildPythonPackage rec {
  pname = "datasette-publish-fly";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = version;
    sha256 = "0wy7lqigjk76c3jw1chrzrn8gva3jzh1q5sbbb54xaa20w8c29da";
  };

  propagatedBuildInputs = [ datasette ];

  checkInputs = [ pytestCheckHook pytest-asyncio sqlite-utils ];

  pythonImportsCheck = [ "datasette_publish_fly" ];

  meta = with lib; {
    description = "Datasette plugin for publishing data using Fly";
    homepage = "https://datasette.io/plugins/datasette-publish-fly";
    license = licenses.asl20;
    maintainers = [ maintainers.MostAwesomeDude ];
  };
}
