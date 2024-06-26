# based on https://github.com/DIYer22/bpycv/blob/c576e01622d87eb3534f73bf1a5686bd2463de97/example/ycb_demo.py
import bpy
import bpycv

import os
import glob
import random
from pathlib import Path

example_data_dir = os.environ['BPY_EXAMPLE_DATA']
out_dir = Path(os.environ['out'])
out_dir.mkdir(parents=True, exist_ok=True)

models = sorted(glob.glob(os.path.join(example_data_dir, "model", "*", "*.obj")))
cat_id_to_model_path = dict(enumerate(sorted(models), 1))

distractors = sorted(glob.glob(os.path.join(example_data_dir, "distractor", "*.obj")))

bpycv.clear_all()
bpy.context.scene.frame_set(1)
bpy.context.scene.render.engine = "CYCLES"
bpy.context.scene.cycles.samples = 32
bpy.context.scene.render.resolution_y = 1024
bpy.context.scene.render.resolution_x = 1024
bpy.context.view_layer.cycles.denoising_store_passes = False

# A transparency stage for holding rigid body
stage = bpycv.add_stage(transparency=True)

bpycv.set_cam_pose(cam_radius=1, cam_deg=45)

hdri_dir = os.path.join(example_data_dir, "background_and_light")
hdri_manager = bpycv.HdriManager(
    hdri_dir=hdri_dir, download=False
)  # if download is True, will auto download .hdr file from HDRI Haven
hdri_path = hdri_manager.sample()
bpycv.load_hdri_world(hdri_path, random_rotate_z=True)

# load 5 objects
for index in range(5):
    cat_id = random.choice(list(cat_id_to_model_path))
    model_path = cat_id_to_model_path[cat_id]
    obj = bpycv.load_obj(model_path)
    obj.location = (
        random.uniform(-0.2, 0.2),
        random.uniform(-0.2, 0.2),
        random.uniform(0.1, 0.3),
    )
    obj.rotation_euler = [random.uniform(-3.1415, 3.1415) for _ in range(3)]
    # set each instance a unique inst_id, which is used to generate instance annotation.
    obj["inst_id"] = cat_id * 1000 + index
    with bpycv.activate_obj(obj):
        bpy.ops.rigidbody.object_add()

# load 6 distractors
for index in range(6):
    distractor_path = random.choice(distractors)
    target_size = random.uniform(0.1, 0.3)
    distractor = bpycv.load_distractor(distractor_path, target_size=target_size)
    distractor.location = (
        random.uniform(-0.2, 0.2),
        random.uniform(-0.2, 0.2),
        random.uniform(0.1, 0.3),
    )
    distractor.rotation_euler = [random.uniform(-3.1415, 3.1415) for _ in range(3)]
    with bpycv.activate_obj(distractor):
        bpy.ops.rigidbody.object_add()

# run pyhsic engine for 20 frames
for i in range(20):
    bpy.context.scene.frame_set(bpy.context.scene.frame_current + 1)

# render image, instance annoatation and depth in one line code
result = bpycv.render_data()


result.save(dataset_dir=str(out_dir.resolve()), fname="0", save_blend=True)
print(f'Save to "{out_dir}"')
print(f'Open "{out_dir}/vis/" to see visualize result.')

