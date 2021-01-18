{ stdenv, buildPythonPackage, fetchFromGitHub
, pbr, click, dataclasses-json, htmlmin, jinja2, markdown2, pygments, pytz, pyyaml, requests, pytestCheckHook, beautifulsoup4, tox
}:

buildPythonPackage rec {
  pname = "json-schema-for-humans";
  version = "0.27.1";

  src = fetchFromGitHub {
    owner = "coveooss";
    repo = pname;
    rev = "v${version}";
    sha256 = "0d2a4a2lcqssr5g9rmc76f86nkqc9grixh507vzc9fi1h3gbi765";
  };

  nativeBuildInputs = [ pbr ];
  propagatedBuildInputs = [
    click dataclasses-json htmlmin jinja2 markdown2
    pygments pytz pyyaml requests
  ];

  preBuild = ''
    export PBR_VERSION=0.0.1
  '';

  checkInputs = [ pytestCheckHook beautifulsoup4 ];
  pytestFlagsArray = [ "--ignore tests/generate_test.py" ];

  meta = with stdenv.lib; {
    description = "Quickly generate HTML documentation from a JSON schema";
    homepage    = "https://github.com/coveooss/json-schema-for-humans";
    license     = licenses.asl20;
    maintainers = with maintainers; [ astro ];
  };
}
