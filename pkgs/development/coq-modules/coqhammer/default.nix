{ lib, mkCoqDerivation, coq, version ? null }:

with lib; mkCoqDerivation {
  inherit version;
  pname = "coqhammer";
  owner = "lukaszcz";
  defaultVersion = with versions; switch coq.coq-version [
    { case = "8.13"; out = "1.3.1-coq8.13"; }
    { case = "8.12"; out = "1.3.1-coq8.12"; }
    { case = "8.11"; out = "1.3.1-coq8.11"; }
    { case = "8.10"; out = "1.3.1-coq8.10"; }
    { case = "8.9";  out = "1.1.1-coq8.9"; }
    { case = "8.8";  out = "1.1-coq8.8"; }
  ] null;
  release."1.3.1-coq8.13".sha256 = "033j6saw24anb1lqbgsg1zynxi2rnxq7pgqwh11k8r8y3xisz78w";
  release."1.3.1-coq8.12".sha256 = "0xy3vy4rv8w5ydwb9nq8y4dcimd91yr0hak2j4kn02svssg1kv1y";
  release."1.3.1-coq8.11".sha256 = "0i9nlcayq0ac95vc09d1w8sd221gdjs0g215n086qscqjwimnz8j";
  release."1.3.1-coq8.10".sha256 = "0aq9qwqx680lkidhb77fmyq403rvfcdxch849x1pzy6a48rz5yra";
  release."1.3-coq8.12".sha256   = "1q1y3cwhd98pkm98g71fsdjz85bfwgcz2xn7s7wwmiraifv5l6z8";
  release."1.3-coq8.11".sha256   = "08zf8qfna7b9p2myfaz4g7bas3a1q1156x78n5isqivlnqfrjc1b";
  release."1.3-coq8.10".sha256   = "1fj8497ir4m79hyrmmmmrag01001wrby0h24wv6525vz0w5py3cd";
  release."1.1.1-coq8.9".sha256  = "1knjmz4hr8vlp103j8n4fyb2lfxysnm512gh3m2kp85n6as6fvb9";
  release."1.1-coq8.8".sha256    = "0ms086wp4jmrzyglb8wymchzyflflk01nsfsk4r6qv8rrx81nx9h";

  release."1.3.1-coq8.13".version  = "1.3.1";
  release."1.3.1-coq8.12".version  = "1.3.1";
  release."1.3.1-coq8.11".version  = "1.3.1";
  release."1.3.1-coq8.10".version  = "1.3.1";
  release."1.3-coq8.12".version  = "1.3";
  release."1.3-coq8.11".version  = "1.3";
  release."1.3-coq8.10".version  = "1.3";
  release."1.1.1-coq8.9".version = "1.1.1";
  release."1.1-coq8.9".version   = "1.1";
  releaseRev = v: "v${v}";

  postPatch = ''
    substituteInPlace Makefile.coq.local --replace \
      '$(if $(COQBIN),$(COQBIN),`coqc -where | xargs dirname | xargs dirname`/bin/)' \
      '$(out)/bin/'
    substituteInPlace Makefile.coq.local --replace 'g++' 'c++' --replace 'gcc' 'cc'
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  mlPlugin = true;

  meta = {
    homepage = "http://cl-informatik.uibk.ac.at/cek/coqhammer/";
    description = "Automation for Dependent Type Theory";
    license = licenses.lgpl21;
    maintainers = [ maintainers.vbgl ];
  };
}
