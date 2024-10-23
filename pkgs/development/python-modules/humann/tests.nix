{ runCommand, python3Packages }:

{
  humann-tests =
    runCommand "humann-tests" { nativeBuildInputs = with python3Packages; [ humann ]; }
      ''
        humann_test --run-functional-tests-tools
        echo "SUCCESS" > $out
      '';
  humann-tests-full =
    runCommand "humann-tests-full" { nativeBuildInputs = with python3Packages; [ humann ]; }
      ''
        humann_test --run-functional-tests-tools --run-functional-tests-end-to-end
        echo "SUCCESS" > $out
      '';
  humann-demos =
    runCommand "humann-demos" { nativeBuildInputs = with python3Packages; [ humann ]; }
      ''
        mkdir -p $out/fasta $out/fastq $out/sam $out/blastm8
        humann --input ${python3Packages.humann.src}/examples/demo.fasta --output $out/fasta
        humann --input ${python3Packages.humann.src}/examples/demo.fastq --output $out/fastq
        humann --input ${python3Packages.humann.src}/examples/demo.sam --output $out/sam
        humann --input ${python3Packages.humann.src}/examples/demo.m8 --output $out/blastm8
      '';
}
