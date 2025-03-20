{ runCommandCC, tfk8s }:

runCommandCC "tfk8s-test-sample1"
  {
    buildInputs = [
      tfk8s
    ];
    meta.timeout = 60;
  }
  ''
    cmp <(${tfk8s}/bin/tfk8s -f ${./input.yaml}) ${./output.tf} > $out
  ''
