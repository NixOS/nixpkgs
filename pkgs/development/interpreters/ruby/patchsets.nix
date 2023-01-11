{ patchSet, useRailsExpress, ops, patchLevel, fetchpatch }:

{
  "2.7.6" = ops useRailsExpress [
    "${patchSet}/patches/ruby/2.7/head/railsexpress/01-fix-with-openssl-dir-option.patch"
    "${patchSet}/patches/ruby/2.7/head/railsexpress/02-fix-broken-tests-caused-by-ad.patch"
    "${patchSet}/patches/ruby/2.7/head/railsexpress/03-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.7/head/railsexpress/04-more-detailed-stacktrace.patch"
    "${patchSet}/patches/ruby/2.7/head/railsexpress/05-malloc-trim.patch"
  ];
  "3.0.4" = ops useRailsExpress [
    "${patchSet}/patches/ruby/3.0/head/railsexpress/01-fix-with-openssl-dir-option.patch"
    "${patchSet}/patches/ruby/3.0/head/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/3.0/head/railsexpress/03-malloc-trim.patch"
  ];
  "3.1.2" = ops useRailsExpress [
    "${patchSet}/patches/ruby/3.1/head/railsexpress/01-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/3.1/head/railsexpress/02-malloc-trim.patch"
  ];
  "3.2.0" = ops useRailsExpress [
    "${patchSet}/patches/ruby/3.2/head/railsexpress/01-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/3.2/head/railsexpress/02-malloc-trim-patch.patch"
  ];
}
