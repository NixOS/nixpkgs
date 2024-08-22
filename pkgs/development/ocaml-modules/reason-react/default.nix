{
  buildDunePackage,
  melange,
  reason,
  reason-react-ppx,
}:

buildDunePackage {
  pname = "reason-react";
  inherit (reason-react-ppx) version src;
  nativeBuildInputs = [
    reason
    melange
  ];
  buildInputs = [
    reason-react-ppx
    melange
  ];
  doCheck = true;
  meta = reason-react-ppx.meta // {
    description = "Reason bindings for React.js";
  };
}
