{ stdenv, lib }:
[
  rec { sha1 = "e27d8ab4f984f9d186f54da984a6ab1cccac755e"; name = "ANTLR4_${sha1}/antlr4.jar"; url = mirror://maven/org/antlr/antlr4-runtime/4.7.2/antlr4-runtime-4.7.2.jar; }
  rec { sha1 = "0da08b8cce7bbf903602a25a3a163ae252435795"; name = "ASM5_${sha1}/asm5.jar"; url = mirror://maven/org/ow2/asm/asm/5.0.4/asm-5.0.4.jar; }
  rec { sha1 = "396ce0c07ba2b481f25a70195c7c94922f0d1b0b"; name = "ASM_TREE5_${sha1}/asm-tree5.jar"; url = mirror://maven/org/ow2/asm/asm-tree/5.0.4/asm-tree-5.0.4.jar; }
  rec { sha1 = "fa29aa438674ff19d5e1386d2c3527a0267f291e"; name = "ASM_7.1_${sha1}/asm-7.1.jar"; url = mirror://maven/org/ow2/asm/asm/7.1/asm-7.1.jar; }
  rec { sha1 = "9d170062d595240da35301362b079e5579c86f49"; name = "ASM_7.1_${sha1}/asm-7.1.sources.jar"; url = mirror://maven/org/ow2/asm/asm/7.1/asm-7.1-sources.jar; }
  rec { sha1 = "379e0250f7a4a42c66c5e94e14d4c4491b3c2ed3"; name = "ASM_ANALYSIS_7.1_${sha1}/asm-analysis-7.1.jar"; url = mirror://maven/org/ow2/asm/asm-analysis/7.1/asm-analysis-7.1.jar; }
  rec { sha1 = "36789198124eb075f1a5efa18a0a7812fb16f47f"; name = "ASM_ANALYSIS_7.1_${sha1}/asm-analysis-7.1.sources.jar"; url = mirror://maven/org/ow2/asm/asm-analysis/7.1/asm-analysis-7.1-sources.jar; }
  rec { sha1 = "431dc677cf5c56660c1c9004870de1ed1ea7ce6c"; name = "ASM_COMMONS_7.1_${sha1}/asm-commons-7.1.jar"; url = mirror://maven/org/ow2/asm/asm-commons/7.1/asm-commons-7.1.jar; }
  rec { sha1 = "a62ff3ae6e37affda7c6fb7d63b89194c6d006ee"; name = "ASM_COMMONS_7.1_${sha1}/asm-commons-7.1.sources.jar"; url = mirror://maven/org/ow2/asm/asm-commons/7.1/asm-commons-7.1-sources.jar; }
  rec { sha1 = "a3662cf1c1d592893ffe08727f78db35392fa302"; name = "ASM_TREE_7.1_${sha1}/asm-tree-7.1.jar"; url = mirror://maven/org/ow2/asm/asm-tree/7.1/asm-tree-7.1.jar; }
  rec { sha1 = "157238292b551de8680505fa2d19590d136e25b9"; name = "ASM_TREE_7.1_${sha1}/asm-tree-7.1.sources.jar"; url = mirror://maven/org/ow2/asm/asm-tree/7.1/asm-tree-7.1-sources.jar; }
  rec { sha1 = "ec2544ab27e110d2d431bdad7d538ed509b21e62"; name = "COMMONS_MATH3_3_2_${sha1}/commons-math3-3-2.jar"; url = mirror://maven/org/apache/commons/commons-math3/3.2/commons-math3-3.2.jar; }
  rec { sha1 = "cd098e055bf192a60c81d81893893e6e31a6482f"; name = "COMMONS_MATH3_3_2_${sha1}/commons-math3-3-2.sources.jar"; url = mirror://maven/org/apache/commons/commons-math3/3.2/commons-math3-3.2-sources.jar; }
  rec { sha1 = "42a25dc3219429f0e5d060061f71acb49bf010a0"; name = "HAMCREST_${sha1}/hamcrest.jar"; url = mirror://maven/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar; }
  rec { sha1 = "1dc37250fbc78e23a65a67fbbaf71d2e9cbc3c0b"; name = "HAMCREST_${sha1}/hamcrest.sources.jar"; url = mirror://maven/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3-sources.jar; }
  rec { sha1 = "d0bdc21c5e6404726b102998e44c66a738897905"; name = "JAVA_ALLOCATION_INSTRUMENTER_${sha1}/java-allocation-instrumenter.jar"; url = mirror://maven/com/google/code/java-allocation-instrumenter/java-allocation-instrumenter/3.1.0/java-allocation-instrumenter-3.1.0.jar; }
  rec { sha1 = "3e9cfc02750ba8ea3babc1b8546a50ec36b849a2"; name = "JAVACPP_SHADOWED_${sha1}/javacpp-shadowed.sources.jar"; url = https://lafo.ssw.uni-linz.ac.at/pub/graal-external-deps/native-image/javacpp-shadowed-1.5.2-sources.jar; }
  rec { sha1 = "212aaddcd73448c7b6da781fb6cde934c667dc2c"; name = "JAVACPP_SHADOWED_${sha1}/javacpp-shadowed.jar"; url = https://lafo.ssw.uni-linz.ac.at/pub/graal-external-deps/native-image/javacpp-shadowed-1.5.2.jar; }
  rec { sha1 = "53addc878614171ff0fcbc8f78aed12175c22cdb"; name = "JACOCOCORE_0.8.4_${sha1}/jacococore-0.8.4.jar"; url = mirror://maven/org/jacoco/org.jacoco.core/0.8.4/org.jacoco.core-0.8.4.jar; }
  rec { sha1 = "9bd1fa334d941005bc9ab3ac92478a590f5b7d73"; name = "JACOCOCORE_0.8.4_${sha1}/jacococore-0.8.4.sources.jar"; url = mirror://maven/org/jacoco/org.jacoco.core/0.8.4/org.jacoco.core-0.8.4-sources.jar; }
  rec { sha1 = "e5ca9511493b7e3bc2cabdb8ded92e855f3aac32"; name = "JACOCOREPORT_0.8.4_${sha1}/jacocoreport-0.8.4.jar"; url = mirror://maven/org/jacoco/org.jacoco.report/0.8.4/org.jacoco.report-0.8.4.jar; }
  rec { sha1 = "eb61e479b35b467954f28a565c094c563b790e19"; name = "JACOCOREPORT_0.8.4_${sha1}/jacocoreport-0.8.4.sources.jar"; url = mirror://maven/org/jacoco/org.jacoco.report/0.8.4/org.jacoco.report-0.8.4-sources.jar; }
  rec { sha1 = "c3aeac59c022bdc497c8c48ed86fa50450e4896a"; name = "JLINE_${sha1}/jline.jar"; url = mirror://maven/jline/jline/2.14.6/jline-2.14.6.jar; }
  rec { sha1 = "442447101f63074c61063858033fbfde8a076873"; name = "JMH_1_21_${sha1}/jmh-1-21.jar"; url = mirror://maven/org/openjdk/jmh/jmh-core/1.21/jmh-core-1.21.jar; }
  rec { sha1 = "a6fe84788bf8cf762b0e561bf48774c2ea74e370"; name = "JMH_1_21_${sha1}/jmh-1-21.sources.jar"; url = mirror://maven/org/openjdk/jmh/jmh-core/1.21/jmh-core-1.21-sources.jar; }
  rec { sha1 = "7aac374614a8a76cad16b91f1a4419d31a7dcda3"; name = "JMH_GENERATOR_ANNPROCESS_1_21_${sha1}/jmh-generator-annprocess-1-21.jar"; url = mirror://maven/org/openjdk/jmh/jmh-generator-annprocess/1.21/jmh-generator-annprocess-1.21.jar; }
  rec { sha1 = "fb48e2a97df95f8b9dced54a1a37749d2a64d2ae"; name = "JMH_GENERATOR_ANNPROCESS_1_21_${sha1}/jmh-generator-annprocess-1-21.sources.jar"; url = mirror://maven/org/openjdk/jmh/jmh-generator-annprocess/1.21/jmh-generator-annprocess-1.21-sources.jar; }
  rec { sha1 = "306816fb57cf94f108a43c95731b08934dcae15c"; name = "JOPTSIMPLE_4_6_${sha1}/joptsimple-4-6.jar"; url = mirror://maven/net/sf/jopt-simple/jopt-simple/4.6/jopt-simple-4.6.jar; }
  rec { sha1 = "9cd14a61d7aa7d554f251ef285a6f2c65caf7b65"; name = "JOPTSIMPLE_4_6_${sha1}/joptsimple-4-6.sources.jar"; url = mirror://maven/net/sf/jopt-simple/jopt-simple/4.6/jopt-simple-4.6-sources.jar; }
  rec { sha1 = "2973d150c0dc1fefe998f834810d68f278ea58ec"; name = "JUNIT_${sha1}/junit.jar"; url = mirror://maven/junit/junit/4.12/junit-4.12.jar; }
  rec { sha1 = "a6c32b40bf3d76eca54e3c601e5d1470c86fcdfa"; name = "JUNIT_${sha1}/junit.sources.jar"; url = mirror://maven/junit/junit/4.12/junit-4.12-sources.jar; }
  rec { sha1 = "280c265b789e041c02e5c97815793dfc283fb1e6"; name = "LIBFFI_SOURCES_${sha1}/libffi-sources.tar.gz"; url = https://lafo.ssw.uni-linz.ac.at/pub/graal-external-deps/libffi-3.2.1.tar.gz; }
  rec { sha1 = "53acc3692e0f67f3b4a4e5fa5b4a5a1de1aa7947"; name = "LLVM_PLATFORM_SPECIFIC_SHADOWED_${sha1}/llvm-platform-specific-shadowed.jar"; url = https://lafo.ssw.uni-linz.ac.at/pub/graal-external-deps/native-image/llvm-shadowed-9.0.0-1.5.2-linux-x86_64.jar; }
  rec { sha1 = "f2d365a8d432d6b2127acda19c5d3418126db9b0"; name = "LLVM_WRAPPER_SHADOWED_${sha1}/llvm-wrapper-shadowed.jar"; url = https://lafo.ssw.uni-linz.ac.at/pub/graal-external-deps/native-image/llvm-shadowed-9.0.0-1.5.2.jar; }
  rec { sha1 = "0801daf22b189bbd9d515614a2b79c92af225d56"; name = "LLVM_WRAPPER_SHADOWED_${sha1}/llvm-wrapper-shadowed.sources.jar"; url = https://lafo.ssw.uni-linz.ac.at/pub/graal-external-deps/native-image/llvm-shadowed-9.0.0-1.5.2-sources.jar; }
] ++ lib.optionals stdenv.isLinux [
  rec { sha1 = "99376a9944e2dfac27087df54c31915f29c6d47e"; name = "LLVM_ORG_${sha1}/llvm-org.tar.gz"; url = https://lafo.ssw.uni-linz.ac.at/pub/llvm-org/llvm-llvmorg-9.0.0-4-g9cf46c329d-bgf06552bd84-linux-amd64.tar.gz; }
  rec { sha1 = "d585d7165e658eade76c384d3bf0695560c2bf3a"; name = "LLVM_ORG_COMPILER_RT_LINUX_${sha1}/llvm-org-compiler-rt-linux.tar.gz"; url = https://lafo.ssw.uni-linz.ac.at/pub/llvm-org/compiler-rt-llvmorg-9.0.0-4-g9cf46c329d-bgf06552bd84-linux-amd64.tar.gz; }
]
