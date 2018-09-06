{stdenv, buildOcamlJane, async_kernel,
 async_unix, async_extra}:

buildOcamlJane rec {
  name = "async";
  version = "113.33.03";
  hash = "0wyspkp8k833fh03r3h016nbfn6kjfhvb2bg42cly6agcak59fmr";
  propagatedBuildInputs = [ async_kernel async_unix async_extra ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/async;
    description = "Jane Street Capital's asynchronous execution library";
    license = licenses.asl20;
    maintainers = [ maintainers.maurer maintainers.ericbmerritt ];
  };
}
