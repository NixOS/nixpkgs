{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ocaml,
  alcotest,
  result,
}:

buildDunePackage (finalAttrs: {
  pname = "dispatch";
  version = "0.5.0";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = "ocaml-dispatch";
    rev = finalAttrs.version;
    hash = "sha256-ZHff/2MQ1chPyshM6X5jnNsOX2iwKckXO0mwvqhPI4s=";
  };

  propagatedBuildInputs = [ result ];

  checkInputs = [ alcotest ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.bsd3;
    description = "Path-based dispatching for client- and server-side applications";
    maintainers = [ lib.maintainers.vbgl ];
  };

})
