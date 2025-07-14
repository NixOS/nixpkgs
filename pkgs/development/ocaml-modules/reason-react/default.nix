{
  buildDunePackage,
  fetchpatch,
  melange,
  reason,
  reason-react-ppx,
}:

buildDunePackage {
  pname = "reason-react";
  inherit (reason-react-ppx) version src;
  patches = [
    # Makes tests compatible with melange 5.0.0
    (fetchpatch {
      url = "https://github.com/reasonml/reason-react/commit/661e93553ae48af410895477c339be4f0a203437.patch";
      includes = [ "test/*" ];
      hash = "sha256-khxPxC/GpByjcEZDoQ1NdXoM/yQBAKmnUnt/d2k6WfQ=";
    })
  ];
  nativeBuildInputs = [
    reason
    melange
  ];
  buildInputs = [
    reason-react-ppx
    melange
  ];
  doCheck = true;
  # Fix tests with dune 3.17.0
  # See https://github.com/reasonml/reason-react/issues/870
  preCheck = ''
    export DUNE_CACHE=disabled
  '';
  meta = reason-react-ppx.meta // {
    description = "Reason bindings for React.js";
  };
}
