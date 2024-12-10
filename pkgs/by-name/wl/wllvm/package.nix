{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  version = "1.3.1";
  pname = "wllvm";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PgV6V18FyezIZpqMQEbyv98MaVM7h7T7/Kvg3yMMwzE=";
  };

  meta = with lib; {
    homepage = "https://github.com/travitch/whole-program-llvm";
    description = "Wrapper script to build whole-program LLVM bitcode files";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.all;
  };
}
