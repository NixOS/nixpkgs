{
  buildDunePackage,
  dune-configurator,
  fetchurl,
  kqueue,
  lib,
  ppx_expect,
  ppx_optcomp,
}:

buildDunePackage (finalAttrs: {
  pname = "poll";
  version = "0.3.1";

  minimalOCamlVersion = "4.13";

  src = fetchurl {
    url = "https://github.com/anuragsoni/poll/releases/download/${finalAttrs.version}/poll-${finalAttrs.version}.tbz";
    hash = "sha256-IX6SivK/IMQaGgMgWiIsNgUSMHP6z1E/TSB0miaQ8pw=";
  };

  buildInputs = [
    dune-configurator
    ppx_optcomp
  ];

  propagatedBuildInputs = [
    kqueue
  ];

  checkInputs = [
    ppx_expect
  ];

  doCheck = true;

  meta = {
    description = "Portable OCaml interface to macOS/Linux/Windows native IO event notification mechanisms";
    homepage = "https://github.com/anuragsoni/poll";
    changelog = "https://github.com/anuragsoni/poll/blob/${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sixstring982 ];
  };
})
