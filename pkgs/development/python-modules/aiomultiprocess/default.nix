{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aiomultiprocess";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "omnilib";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vkj1vgvlv828pi3sn0hjzdy9f0j63gljs2ylibbsaixa7mbkpvy";
  };

  checkInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "aiomultiprocess/tests/*.py" ];
  pythonImportsCheck = [ "aiomultiprocess" ];

  meta = with lib; {
    description = "Python module to improve performance";
    longDescription = ''
      aiomultiprocess presents a simple interface, while running a full
      AsyncIO event loop on each child process, enabling levels of
      concurrency never before seen in a Python application. Each child
      process can execute multiple coroutines at once, limited only by
      the workload and number of cores available.
    '';
    homepage = "https://github.com/omnilib/aiomultiprocess";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.fab ];
  };
}
