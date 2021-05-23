--- a/src/fcatomic.h	2020-11-27 13:23:44.000000000 +0900
+++ b/src/fcatomic.h	2020-11-27 13:24:43.000000000 +0900
@@ -70,24 +70,25 @@
 #elif !defined(FC_NO_MT) && defined(__APPLE__)
 
 #include <libkern/OSAtomic.h>
-#ifdef __MAC_OS_X_MIN_REQUIRED
 #include <AvailabilityMacros.h>
-#elif defined(__IPHONE_OS_MIN_REQUIRED)
-#include <Availability.h>
-#endif
 
 typedef int fc_atomic_int_t;
 #define fc_atomic_int_add(AI, V)	(OSAtomicAdd32Barrier ((V), &(AI)) - (V))
 
-#define fc_atomic_ptr_get(P)		(OSMemoryBarrier (), (void *) *(P))
-#if (MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_4 || __IPHONE_VERSION_MIN_REQUIRED >= 20100)
-#define fc_atomic_ptr_cmpexch(P,O,N)	OSAtomicCompareAndSwapPtrBarrier ((void *) (O), (void *) (N), (void **) (P))
-#else
-#if __ppc64__ || __x86_64__
-#define fc_atomic_ptr_cmpexch(P,O,N)	OSAtomicCompareAndSwap64Barrier ((int64_t) (O), (int64_t) (N), (int64_t*) (P))
+#if (MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_4 || __IPHONE_OS_VERSION_MIN_REQUIRED >= 20100)
+
+#if SIZEOF_VOID_P == 8
+#define fc_atomic_ptr_get(P)		OSAtomicAdd64Barrier (0, (int64_t*)(P))
+#elif SIZEOF_VOID_P == 4
+#define fc_atomic_ptr_get(P)		OSAtomicAdd32Barrier (0, (int32_t*)(P))
 #else
-#define fc_atomic_ptr_cmpexch(P,O,N)	OSAtomicCompareAndSwap32Barrier ((int32_t) (O), (int32_t) (N), (int32_t*) (P))
+#error "SIZEOF_VOID_P not 4 or 8 (assumes CHAR_BIT is 8)"
 #endif
+
+#define fc_atomic_ptr_cmpexch(P,O,N)	OSAtomicCompareAndSwapPtrBarrier ((void *) (O), (void *) (N), (void **) (P))
+
+#else
+#error "Your macOS / iOS targets are too old"
 #endif
 
 #elif !defined(FC_NO_MT) && defined(HAVE_INTEL_ATOMIC_PRIMITIVES)
