{ patchSet, useRailsExpress, ops, patchLevel, fetchpatch }:

{
  "2.6.6" = ops useRailsExpress [
    "${patchSet}/patches/ruby/2.6/head/railsexpress/01-fix-broken-tests-caused-by-ad.patch"
    "${patchSet}/patches/ruby/2.6/head/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.6/head/railsexpress/03-more-detailed-stacktrace.patch"
  ];
  "2.7.2" = ops useRailsExpress [
    "${patchSet}/patches/ruby/2.7/head/railsexpress/01-fix-broken-tests-caused-by-ad.patch"
    "${patchSet}/patches/ruby/2.7/head/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.7/head/railsexpress/03-more-detailed-stacktrace.patch"
  ];
  "3.0.1" = ops useRailsExpress [
    "${patchSet}/patches/ruby/3.0/head/railsexpress/01-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/3.0/head/railsexpress/02-malloc-trim.patch"
  ];
}
