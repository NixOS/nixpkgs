From 0d936b3e64e1e629bd29fa4dd84240f5c5344092 Mon Sep 17 00:00:00 2001
From: LN Liberda <lauren@selfisekai.rocks>
Date: Tue, 26 Nov 2024 19:28:59 +0100
Subject: [PATCH] build: option to not embed icu data

Bug: none
---
 runtime/bin/BUILD.gn     | 11 ++++++++---
 runtime/runtime_args.gni |  3 +++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/runtime/bin/BUILD.gn b/runtime/bin/BUILD.gn
index 90dc09a0c02..8f88873dc18 100644
--- a/runtime/bin/BUILD.gn
+++ b/runtime/bin/BUILD.gn
@@ -795,7 +795,6 @@ template("dart_executable") {
     }
     deps = [
       ":crashpad",
-      ":icudtl_cc",
       "//third_party/boringssl",
       "//third_party/icu:icui18n",
       "//third_party/icu:icuuc",
@@ -804,7 +803,11 @@ template("dart_executable") {
     if (is_fuchsia) {
       deps += [ "$fuchsia_sdk/pkg/fdio" ]
     }
-    defines = [ "DART_EMBED_ICU_DATA" ] + extra_defines
+    defines = extra_defines
+    if (dart_embed_icu_data) {
+      defines += [ "DART_EMBED_ICU_DATA" ]
+      deps += [ ":icudtl_cc" ]
+    }
     if (exclude_kernel_service) {
       defines += [ "EXCLUDE_CFE_AND_KERNEL_PLATFORM" ]
     }
@@ -1004,10 +1004,12 @@
     "..:add_empty_macho_section_config",
   ]
   extra_deps = [
-    ":icudtl_cc",
     "..:libdart_aotruntime",
     "../platform:libdart_platform_aotruntime",
   ]
+  if (dart_embed_icu_data) {
+    extra_deps += [":icudtl_cc"]
+  }
   extra_sources = [
     "builtin.cc",
     "gzip.cc",
diff --git a/runtime/runtime_args.gni b/runtime/runtime_args.gni
index fbcfeb157fb..061e8f74a5c 100644
--- a/runtime/runtime_args.gni
+++ b/runtime/runtime_args.gni
@@ -77,6 +77,9 @@ declare_args() {
 
   # Whether to support dynamic loading and interpretation of Dart bytecode.
   dart_dynamic_modules = false
+
+  # Whether to embed ICU data inside the runtime binary.
+  dart_embed_icu_data = true
 }
 
 declare_args() {
