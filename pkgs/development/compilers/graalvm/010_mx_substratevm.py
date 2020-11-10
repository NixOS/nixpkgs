diff --git a/substratevm/mx.substratevm/mx_substratevm.py b/substratevm/mx.substratevm/mx_substratevm.py
index b89163ef983..0fd0138b336 100644
--- a/substratevm/mx.substratevm/mx_substratevm.py
+++ b/substratevm/mx.substratevm/mx_substratevm.py
@@ -189,7 +189,7 @@ if str(svm_java_compliance().value) not in GRAAL_COMPILER_FLAGS_MAP:
     mx.abort("Substrate VM does not support this Java version: " + str(svm_java_compliance()))
 GRAAL_COMPILER_FLAGS = GRAAL_COMPILER_FLAGS_BASE + GRAAL_COMPILER_FLAGS_MAP[str(svm_java_compliance().value)]
 
-IMAGE_ASSERTION_FLAGS = ['-H:+VerifyGraalGraphs', '-H:+VerifyPhases']
+IMAGE_ASSERTION_FLAGS = ['-H:+VerifyGraalGraphs', '-H:+VerifyPhases', '-H:+ReportExceptionStackTraces']
 suite = mx.suite('substratevm')
 svmSuites = [suite]
 clibraryDists = ['SVM_HOSTED_NATIVE']
