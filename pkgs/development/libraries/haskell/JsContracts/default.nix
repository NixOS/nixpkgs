{cabal, WebBits, WebBitsHtml}:

cabal.mkDerivation (self : {
  pname = "JsContracts";
  version = "0.5.3";
  sha256 = "17l6kdpdc7lrpd9j4d2b6vklkpclshcjy6hzpi442b7pj96sn589";

  propagatedBuildInputs = [ WebBits WebBitsHtml ];

  meta = {
    description = "Design-by-contract for JavaScript.";
  };
})
