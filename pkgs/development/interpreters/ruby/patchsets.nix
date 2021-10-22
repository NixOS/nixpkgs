{ patchSet, useRailsExpress, ops, patchLevel, fetchpatch }:

{
  "2.7.4" = ops useRailsExpress [
    "${patchSet}/patches/ruby/2.7/head/railsexpress/01-fix-broken-tests-caused-by-ad.patch"
    "${patchSet}/patches/ruby/2.7/head/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.7/head/railsexpress/03-more-detailed-stacktrace.patch"
  ];
  "3.0.2" = ops useRailsExpress [
    "${patchSet}/patches/ruby/3.0/head/railsexpress/01-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/3.0/head/railsexpress/02-malloc-trim.patch"
  ];
}
