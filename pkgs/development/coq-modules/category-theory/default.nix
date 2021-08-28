{ lib, mkCoqDerivation, coq, ssreflect, equations, version ? null }:

with lib; mkCoqDerivation {

  pname = "category-theory";
  owner = "jwiegley";

  release."20190414".rev    = "706fdb4065cc2302d92ac2bce62cb59713253119";
  release."20190414".sha256 = "16lg4xs2wzbdbsn148xiacgl4wq4xwfqjnjkdhfr3w0qh1s81hay";
  release."20180709".rev    = "3b9ba7b26a64d49a55e8b6ccea570a7f32c11ead";
  release."20180709".sha256 = "0f2nr8dgn1ab7hr7jrdmr1zla9g9h8216q4yf4wnff9qkln8sbbs";

  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = range "8.8" "8.9"; out = "20190414"; }
    { case = range "8.6" "8.7"; out = "20180709"; }
  ] null;

  mlPlugin = true;
  propagatedBuildInputs = [ ssreflect equations ];

  meta = {
    description = "A formalization of category theory in Coq for personal study and practical work";
    maintainers = with maintainers; [ jwiegley ];
  };
}
