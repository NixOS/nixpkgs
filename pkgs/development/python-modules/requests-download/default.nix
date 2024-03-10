{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "requests-download";
  version = "0.1.2";

  format = "wheel";

  #src = pkgs.fetchurl {
  #  url = "https://files.pythonhosted.org/packages/60/af/10f899f0574a81cbc511124c08d7c7dc46c20d4f956a6a3c793ad4330bb4/requests_download-0.1.2-py2.py3-none-any.whl";
  #  sha256 = "1ballx1hljpdpyvqzqn79m0dc21z2smrnxk2ylb6dbpg5crrskcr";
  #};

  src = fetchPypi {
    pname = "requests_download";
    inherit version format;
    sha256 = "1ballx1hljpdpyvqzqn79m0dc21z2smrnxk2ylb6dbpg5crrskcr";
  };

  propagatedBuildInputs = [ requests ];

  meta = {
    description = "Download files using requests and save them to a target path";
    homepage = "https://www.github.com/takluyver/requests_download";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.fridh ];
  };
}
