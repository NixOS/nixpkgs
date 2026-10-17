{
  fetchurl,
}:
{
  rules_cc = fetchurl {
    url = "https://github.com/bazelbuild/rules_cc/releases/download/0.0.9/rules_cc-0.0.9.tar.gz";
    hash = "sha256-IDeHW5pEVtzkp50RKorohbvEqtlo5lh9ym5k86CQDN8=";
  };
}
