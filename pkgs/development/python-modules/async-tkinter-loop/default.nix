{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  tkinter,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "async-tkinter-loop";
  version = "0.10.4";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "async_tkinter_loop";
    hash = "sha256-y4gDOXXk4z1gAQVeB+/gOzia4SfICJiXV47pdaEQRp4=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    tkinter
    typing-extensions
  ];

  pythonRemoveDeps = [ "asyncio" ];

  pythonImportsCheck = [ "async_tkinter_loop" ];

  meta = {
    description = "Implementation of asynchronous mainloop for tkinter, the use of which allows using async handler functions";
    homepage = "https://github.com/insolor/async-tkinter-loop";
    changelog = "https://github.com/insolor/async-tkinter-loop/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AngryAnt ];
  };
})
