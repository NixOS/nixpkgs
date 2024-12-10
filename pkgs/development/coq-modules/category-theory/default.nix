{ lib, mkCoqDerivation, coq, ssreflect, equations, version ? null }:

mkCoqDerivation {

  pname = "category-theory";
  owner = "jwiegley";

  release."1.0.0".sha256 = "sha256-qPgho4/VcL3vyMPJAMXXdqhYPEbNeXSZsoWbA/lGek4=";
  release."20211213".rev    = "449e30e929d56f6f90c22af2c91ffcc4d79837be";
  release."20211213".sha256 = "sha256:0vgfmph5l1zn6j4b851rcm43s8y9r83swsz07rpzhmfg34pk0nl0";
  release."20210730".rev    = "d87937faaf7460bcd6985931ac36f551d67e11af";
  release."20210730".sha256 = "04x7433yvibxknk6gy4971yzb4saa3z4dnfy9n6irhyafzlxyf0f";
  release."20190414".rev    = "706fdb4065cc2302d92ac2bce62cb59713253119";
  release."20190414".sha256 = "16lg4xs2wzbdbsn148xiacgl4wq4xwfqjnjkdhfr3w0qh1s81hay";
  release."20180709".rev    = "3b9ba7b26a64d49a55e8b6ccea570a7f32c11ead";
  release."20180709".sha256 = "0f2nr8dgn1ab7hr7jrdmr1zla9g9h8216q4yf4wnff9qkln8sbbs";

  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
    { case = range "8.14" "8.17"; out = "1.0.0"; }
    { case = range "8.10" "8.15"; out = "20211213"; }
    { case = range "8.8" "8.9"; out = "20190414"; }
    { case = range "8.6" "8.7"; out = "20180709"; }
  ] null;

  mlPlugin = true;
  propagatedBuildInputs = [ ssreflect equations ];

  meta = {
    description = "Formalization of category theory in Coq for personal study and practical work";
    maintainers = with lib.maintainers; [ jwiegley ];
  };
}
