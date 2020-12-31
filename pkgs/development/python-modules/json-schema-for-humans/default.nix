{ stdenv, buildPythonPackage, fetchFromGitHub, fetchurl
, pbr, click, dataclasses-json, htmlmin, jinja2, markdown2, pygments, pytz, pyyaml, requests, pytestCheckHook, beautifulsoup4, tox
}:

buildPythonPackage rec {
  pname = "json-schema-for-humans";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "coveooss";
    repo = pname;
    rev = "v${version}";
    sha256 = "1r40i192z6aasil5vsgcgp5yvx392dhhqnfc2qxbxvpja6l3p6p2";
  };

  patches = [ (fetchurl {
    url = "https://github.com/coveooss/json-schema-for-humans/commit/1fe2e2391da5a796204fd1889e4a11a53f83f7c9.patch";
    sha256 = "0kpydpddlg0rib9snl8albhbrrs6d3ds292gpgpg7bdpqrwamdib";
  }) (fetchurl {
    url = "https://github.com/astro/json-schema-for-humans/commit/9bcc9b461102062dff214ca1ec2375b8aea53711.patch";
    sha256 = "142a07v8bn1j20b7177yb60f4944kbx4cdqqq2nz6xkxmamw704d";
  }) ];

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
