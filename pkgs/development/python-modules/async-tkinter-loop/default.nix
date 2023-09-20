{ lib
, buildPythonPackage
, fetchPypi
, python3Packages
, poetry-core
, tkinter
, pythonRelaxDepsHook
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "async-tkinter-loop";
  version = "0.9.1";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "async_tkinter_loop";
    hash = "sha256-Phxx9RovjU5JOonMt7Zhum0/BGRS5OLRAkLTl4L/BW4=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
    poetry-core
  ];

  propagatedBuildInputs = [
    tkinter
  ];

  pythonRemoveDeps = [
    "asyncio"
  ];

  pythonImportsCheck = [
    "async_tkinter_loop"
  ];

  meta = with lib; {
    description = "Implementation of asynchronous mainloop for tkinter, the use of which allows using async handler functions";
    homepage = "https://github.com/insolor/async-tkinter-loop";
    changelog = "https://github.com/insolor/async-tkinter-loop/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ AngryAnt ];
  };
}
