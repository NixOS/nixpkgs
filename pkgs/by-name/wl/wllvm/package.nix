{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "wllvm";
  version = "1.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PgV6V18FyezIZpqMQEbyv98MaVM7h7T7/Kvg3yMMwzE=";
  };

  build-system = with python3Packages; [ setuptools ];

  pythonImportsCheck = [ "wllvm.wllvm" ];

  meta = with lib; {
    homepage = "https://github.com/travitch/whole-program-llvm";
    description = "Wrapper script to build whole-program LLVM bitcode files";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.all;
  };
}
