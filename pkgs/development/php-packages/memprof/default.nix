{ buildPecl
, lib
, fetchFromGitHub
, judy
}:

let
  version = "3.0.2";
in buildPecl {
  inherit version;
  pname = "memprof";

  src = fetchFromGitHub {
    owner = "arnaud-lb";
    repo = "php-memory-profiler";
    rev = version;
    hash = "sha256-K8YcvCobErBkaWFTkVGLXXguQPOLIgQuRGWJF+HAIRA=";
  };

  configureFlags = [
    "--with-judy-dir=${judy}"
  ];

  doCheck = true;

  meta = {
    changelog = "https://github.com/arnaud-lb/php-memory-profiler/releases/tag/${version}";
    description = "Memory profiler for PHP. Helps finding memory leaks in PHP scripts";
    homepage = "https://github.com/arnaud-lb/php-memory-profiler";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gaelreyrol ];
  };
}
