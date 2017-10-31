{stdenv, buildOcamlJane, fetchurl, async_kernel,
 bin_prot, comparelib, core, fieldslib, herelib,
 pipebang, sexplib}:

buildOcamlJane rec {
  name = "async_unix";
  hash = "03ng7f0s22wwzspakiqj442vs1a7yf834109jcj9r3g1awwfhcy7";
  propagatedBuildInputs = [ async_kernel core bin_prot comparelib
                            fieldslib herelib pipebang sexplib ];

  meta = with stdenv.lib; {
   homepage = https://github.com/janestreet/async_unix;
   description = "Jane Street Capital's asynchronous execution library (unix)";
   license = licenses.asl20;
   maintainers = [ maintainers.maurer maintainers.ericbmerritt ];
  };
}
