{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "wllvm";
  version = "1.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-PgV6V18FyezIZpqMQEbyv98MaVM7h7T7/Kvg3yMMwzE=";
  };

  build-system = with python3Packages; [ setuptools ];

  pythonImportsCheck = [ "wllvm.wllvm" ];

  meta = {
    homepage = "https://github.com/travitch/whole-program-llvm";
    description = "Wrapper script to build whole-program LLVM bitcode files";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mic92 ];
    platforms = lib.platforms.all;
  };
})
