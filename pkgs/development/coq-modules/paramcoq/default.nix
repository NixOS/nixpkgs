{ lib, mkCoqDerivation, coq, version ? null }:

with lib; mkCoqDerivation {
  pname = "paramcoq";
  inherit version;
  defaultVersion = if versions.range "8.7" "8.13" coq.coq-version
    then "1.1.2+coq${coq.coq-version}" else null;
  displayVersion = { paramcoq = "1.1.2"; };
  release."1.1.2+coq8.13".sha256 = "02vnf8p04ynf3qk8myvjzsbga15395235mpdpj54pvxis3h5qq22";
  release."1.1.2+coq8.12".sha256 = "0qd72r45if4h7c256qdfiimv75zyrs0w0xqij3m866jxaq591v4i";
  release."1.1.2+coq8.11".sha256 = "09c6813988nvq4fpa45s33k70plnhxsblhm7cxxkg0i37mhvigsa";
  release."1.1.2+coq8.10".sha256 = "1lq1mw15w4yky79qg3rm0mpzqi2ir51b6ak04ismrdr7ixky49y8";
  release."1.1.2+coq8.9".sha256  = "1jjzgpff09xjn9kgp7w69r096jkj0x2ksng3pawrmhmn7clwivbk";
  release."1.1.2+coq8.8".sha256  = "0rc4lshqvnfdsph98gnscvpmlirs9wx91qcvffggg73xw0p1g9s0";
  release."1.1.2+coq8.7".sha256  = "09n0ky7ldb24by7yf5j3hv410h85x50ksilf7qacl7xglj4gy5hj";
  releaseRev = v: "v${v}";
  mlPlugin = true;
  meta = {
    description = "Coq plugin for parametricity";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };
}
