{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage (finalAttrs: {
  pname = "ws";
  version = "0.5.0";
  src = fetchFromGitHub {
    owner = "treeform";
    repo = "ws";
    rev = finalAttrs.version;
    hash = "sha256-3wVi6CjMTjcc5MJEozJN6W3TuYDb53w2MDCsv6lMH0k=";
  };
  preCheck = ''
    rm tests/test_ws.nim tests/test_timeout.nim
  '';
  meta = finalAttrs.src.meta // {
    description = "Simple WebSocket library for Nim";
    homepage = "https://github.com/treeform/ws";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ehmry ];
  };
})
