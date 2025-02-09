{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "websecprobe";
  version = "0.0.10";
  pyproject = true;

  src = fetchPypi {
    pname = "WebSecProbe";
    inherit version;
    hash = "sha256-QvXOyQUptMyim/bgvhihjgGs7vX0qX8MqK2ol8q9ePc=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    requests
    tabulate
  ];

  postInstall = ''
    mv $out/bin/WebSecProbe $out/bin/$pname
  '';

  pythonImportsCheck = [
    "WebSecProbe"
  ];

  meta = with lib; {
    description = "Web Security Assessment Tool";
    homepage = "https://github.com/spyboy-productions/WebSecProbe/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "websecprobe";
  };
}
