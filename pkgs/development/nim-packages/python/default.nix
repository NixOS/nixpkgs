{ lib, buildNimPackage, fetchFromGitHub, python27 }:

buildNimPackage rec {
  pname = "python";
  version = "1.2";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = pname;
    rev = "b7c3b2c447a69fdb0a974ba149062e52182fda08";
    hash = "sha256-Wl4on0rf4zbNxmwmq/ZkNiPIFCZY+1BdokPQoba2EVI=";
  };
  postPatch = let pythonLib = "${python27}/lib/libpython2.7.so";
  in ''
    substituteInPlace src/python.nim \
      --replace 'items(LibNames)' "[\"${pythonLib}\"]" \
      --replace 'dynlib: dllname' 'dynlib: "${pythonLib}"'
  '';
  doCheck = true;
  meta = with lib;
    src.meta // {
      description = "Nim wrapper for the Python 2 programming language";
      license = [ licenses.mit ];
      maintainers = [ maintainers.ehmry ];
    };
}
