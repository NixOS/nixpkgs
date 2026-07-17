{
  fenics-ufl,
}:

fenics-ufl.overrideAttrs (oldAttrs: rec {
  version = "2025.3.0";

  src = oldAttrs.src.override {
    tag = version;
    hash = "sha256-BFeVwurTsFNirpjZlgaABzw/cLzWxXwbCHJQBHrLuOY=";
  };
})
