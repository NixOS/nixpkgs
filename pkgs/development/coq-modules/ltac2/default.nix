{
  lib,
  mkCoqDerivation,
  which,
  coq,
  version ? null,
}:

mkCoqDerivation {
  pname = "ltac2";
  owner = "coq";
  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.coq-version [
      {
        case = "8.10";
        out = "0.3";
      }
      {
        case = "8.9";
        out = "0.2";
      }
      {
        case = "8.8";
        out = "0.1";
      }
      {
        case = "8.7";
        out = "0.1-8.7";
      }
    ] null;
  release."0.3".sha256 = "0pzs5nsakh4l8ffwgn4ryxbnxdv2x0r1i7bc598ij621haxdirrr";
  release."0.2".sha256 = "0xby1kb26r9gcvk5511wqj05fqm9paynwfxlfqkmwkgnfmzk0x73";
  release."0.1".sha256 = "1zz26cyv99whj7rrpgnhhm9dfqnpmrx5pqizn8ihf8jkq8d4drz7";
  release."0.1-8.7".version = "0.1";
  release."0.1-8.7".rev = "v0.1-8.7";
  release."0.1-8.7".sha256 = "0l6wiwi4cvd0i324fb29i9mdh0ijlxzggw4mrjjy695l2qdnlgg0";

  mlPlugin = true;

  meta = with lib; {
    description = "A robust and expressive tactic language for Coq";
    maintainers = [ maintainers.vbgl ];
    license = licenses.lgpl21;
  };
}
