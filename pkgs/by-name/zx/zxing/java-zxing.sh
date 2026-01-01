#! /bin/sh

<<<<<<< HEAD
@jre@/bin/java -cp @out@/lib/java/javase-@version@-jar-with-dependencies.jar "$@"
=======
@jre@/bin/java -cp @out@/lib/java/core-@version@.jar:@out@/lib/java/javase-@version@.jar "$@"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
